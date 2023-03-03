import boto3


def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('DataStore')
    response = table.update_item(
        Key={
            'id': event['id']
        },
        UpdateExpression="SET #Visitor = if_not_exists(#Visitor, :init) + :increment",
        ExpressionAttributeNames={'#Visitor': 'Visitor'},
        ExpressionAttributeValues={':increment': 1, ":init": 0}
    )

    return {
        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'body': 'Successful Update'
    }