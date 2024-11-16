import { describe, expect, vi, it } from "vitest";
import {
  handler,
  captureS3Update,
  getTaskByCluster,
  getContainerInstanceId,
  runCmd,
} from "@/index";

import { SSMClient, SendCommandCommand } from "@aws-sdk/client-ssm";
import { S3Event } from "aws-lambda";


vi.mock("@aws-sdk/client-ecs", () => {
  return {
    ListTasksCommand: class ListTasksCommand {},
    DescribeTasksCommand: class DescribeTasksCommand {},
    DescribeContainerInstancesCommand: class DescribeContainerInstancesCommand {},
    ECSClient: vi.fn().mockImplementation(() => ({
      send: vi.fn().mockImplementation((prop) => {
        const constructorName = prop.constructor.name;
        switch (constructorName) {
          case "ListTasksCommand":
            return {
              taskArns: ["task-arn"],
            };
          case "DescribeTasksCommand":
            return {
              tasks: [
                {
                  containerInstanceArn: "container-instance-arn",
                  containers: [
                    {
                      runtimeId: "container-runtime-id",
                    },
                  ],
                },
              ],
            };
          case "DescribeContainerInstancesCommand":
            return {
              containerInstances: [
                {
                  ec2InstanceId: "ec2-instance-id",
                },
              ],
            };
          default:
            return {};
        }
      }),
    })),
  };
});

vi.mock("@aws-sdk/client-ssm", () => {
  return {
    SSMClient: vi.fn().mockImplementation(() => ({
      send: vi.fn().mockImplementation((prop) => {
        console.log('ssmClient send=', prop);
        return {};
      })
    })),
    SendCommandCommand: class SendCommandCommand {},
  };
});

describe("Lambda Handler", () => {
  it("should capture S3 update correctly", () => {
    const event: S3Event = {
      Records: [
        {
          eventName: "ObjectCreated:Put",
          s3: {
            object: {
              key: "file.txt",
            },
          },
        },
        {
          eventName: "ObjectCreated:Put",
          s3: {
            object: {
              key: "file.temp",
            },
          },
        },
      ],
    };

    expect(captureS3Update(event)).toBe(true);
  });

  it("should get task by cluster", async () => {
    const task = await getTaskByCluster("project-repo");
    expect(task).toEqual({
      containerInstanceArn: "container-instance-arn",
      containers: [
        {
          runtimeId: "container-runtime-id",
        },
      ],
    });
  });

  it("should get container instance ID", async () => {
    const ec2InstanceId = await getContainerInstanceId({
      containerInstanceArn: "container-instance-arn",
      project_repo: "project-repo",
    });
    expect(ec2InstanceId).toBe("ec2-instance-id");
  });

  it("should run commands on the EC2 instance", async () => {
    await runCmd({
      arrCmd: ["command1", "command2"],
      ec2InstanceId: "ec2-instance-id",
    });
    expect(SSMClient).toHaveBeenCalledWith({ region: "us-east-1" });
    expect(SendCommandCommand).toHaveBeenCalledWith({
      DocumentName: "AWS-RunShellScript",
      Parameters: {
        commands: ["command1", "command2"],
      },
      InstanceIds: ["ec2-instance-id"],
    });
  });

  it.only("should handle the lambda event", async () => {
    const event: S3Event = {
      Records: [
        {
          eventName: "ObjectCreated:Put",
          s3: {
            object: {
              key: "file.txt",
            },
          },
        },
      ],
    };

    process.env.AWS_REGION = "us-east-1";
    process.env.project_repo = "project-repo";
    process.env.S3_BUCKET = "my-bucket";
    process.env.HOST_VOLUME_PATH = "/host/volume/path";

    const response = await handler(event);
    expect(response).toEqual({
      statusCode: 200,
      body: JSON.stringify("Successfully initiated S3 sync"),
    });
  });
});
