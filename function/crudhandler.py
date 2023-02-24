import boto3
from botocore.exceptions import ClientError
import logging

logger = logging.getLogger(__name__)

client = boto3.client('dynamodb')

def handler(event, context):

    def create(x):
        client.put_item(**x)

    def read(x):
        client.get_item(**x)
    
    def update(x):
        client.update_item(**x)

    def echo(x):
        return x

    operation = event['operation']

    operations = {
        'create': create,
        'read': read,
        'update': update,
        'echo': echo,
    }
    if operation in operations:
        return operations[operation](event.get('payload'))
    else:
        raise ValueError('Unrecognized operation "{}"'.format(operation))

    # try:
    #     response = client.update_item(
    #         Key={'id': 'current'},
    #         UpdateExpression="set Visitors = Visitors + 1",
    #         ReturnValues="UPDATED_NEW")
    # except ClientError as err:
    #     logger.error(
    #         "Couldn't update viewer count. Here's why: %s: %s",
    #         err.response['Error']['Code'], err.response['Error']['Message'])
    #     raise
    # else:
    #     return response['Attributes']

