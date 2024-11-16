import { CloudWatchLogsEvent } from "aws-lambda";

export const handler = async (
  event: CloudWatchLogsEvent
): Promise<{ statusCode: number; body: string } | void> => {
  console.log("try lambda ec2 ok ok");
  try {
    console.log("Received event:", JSON.stringify(event, null, 2));
    return {
      statusCode: 200,
      body: JSON.stringify("Successfully run lambda: lambdaEC2okOK"),
    };
  } catch (error) {
    console.error("Error starting instance:", error);
    throw error; 
  }
};

