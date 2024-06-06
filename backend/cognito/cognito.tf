resource "aws_cognito_user_pool" "hotel_user_pool" {
  name                     = "hotel-booking-user"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length    = 6
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }
  mfa_configuration = "OFF"

  schema {
    attribute_data_type      = "String"
    name                     = "email"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 2048
      min_length = 0
    }
  }

  schema {
    attribute_data_type      = "String"
    name                     = "address"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 2048
      min_length = 0
    }
  }

  schema {
    attribute_data_type      = "String"
    name                     = "given_name"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 2048
      min_length = 0
    }
  }

  schema {
    attribute_data_type      = "String"
    name                     = "family_name"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 2048
      min_length = 0
    }
  }

  schema {
    attribute_data_type      = "String"
    name                     = "billing_name"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      max_length = 2048
      min_length = 0
    }
  }
}

resource "aws_cognito_user_pool_domain" "hotel_user" {
  domain       = "hotel-application"
  user_pool_id = aws_cognito_user_pool.hotel_user_pool.id
}

resource "aws_cognito_user_pool_client" "web_client" {
  name                                 = "web"
  generate_secret                      = true
  user_pool_id                         = aws_cognito_user_pool.hotel_user_pool.id
  callback_urls                        = ["https://oauth.pstmn.io/v1/callback"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_group" "admin" {
  name         = "Admin"
  user_pool_id = aws_cognito_user_pool.hotel_user_pool.id
}

resource "aws_cognito_user_group" "hotel_manager" {
  name         = "HotelManager"
  user_pool_id = aws_cognito_user_pool.hotel_user_pool.id
}