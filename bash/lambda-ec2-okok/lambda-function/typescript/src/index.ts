// import { EC2Client } from '@aws-sdk/client-ec2';
import { EventBridgeEvent } from "aws-lambda";
import {
  CloudWatchClient,
  SetAlarmStateCommand
} from "@aws-sdk/client-cloudwatch";

// Initialize the EC2 client outside of the handler
// const ec2Client = new EC2Client({});

// Define the expected event detail type for logs
interface LogEventDetail {
  message: string;
}

const {REGION, LAMBDA_FUNCTION_EC2_OKOK } = process.env;


const cloudwatch = new CloudWatchClient({ region: REGION });


// Lambda handler
export const handler = async (
  event: EventBridgeEvent<"aws.logs", LogEventDetail>
): Promise<{ statusCode: number; body: string } | void> => {
  console.log("try lambda ec2 ok ok");
  try {
    console.log("Received event:", JSON.stringify(event, null, 2));

        // Prepare the command to reset the alarm state to OK
        const command = new SetAlarmStateCommand({
          AlarmName: `metric-alarm-${LAMBDA_FUNCTION_EC2_OKOK}`,
          StateValue: 'OK',  // This resets the alarm to OK (can also be 'ALARM' or 'INSUFFICIENT_DATA')
          StateReason: 'Manually resetting the alarm state'  // Custom reason for resetting
      });

      // Send the command to reset the alarm state
      await cloudwatch.send(command);

    return {
      statusCode: 200,
      body: JSON.stringify("Successfully run lambda: lambdaEC2okOK"),
    };
  } catch (error) {
    console.error("Error starting instance:", error);
    throw error;  // Re-throw to mark Lambda as failed
  }
};

// test
// handler({somevent: 'hello'});
