import boto3
from botocore.exceptions import ClientError
import logging

logger = logging.getLogger(__name__)

client = boto3.client('dynamodb')

def handler(event, context):
    try:
        response = client.update_item(
            Key={'id': 'current'},
            UpdateExpression="set Visitors = Visitors + 1",
            ReturnValues="UPDATED_NEW")
    except ClientError as err:
        logger.error(
            "Couldn't update viewer count. Here's why: %s: %s",
            err.response['Error']['Code'], err.response['Error']['Message'])
        raise
    else:
        return response['Attributes']

