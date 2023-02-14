resource "aws_dynamodb_table" "data" {
    name           = "DataStore"
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "id"
    attribute {
        name = "id"
        type = "S"
    }
}

resource "aws_dynamodb_table_item" "initialize" {
    table_name = aws_dynamodb_table.data.name
    hash_key   = aws_dynamodb_table.data.hash_key

    item = <<ITEM
    {
        "id": {"S": "current"},
        "Visitors": {"N": "0"}
    }
    ITEM
}