// Copyright (c) 2022 WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

public type GroupArr Group[];

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
|};

# Provides settings related to HTTP/1.x protocol.
public type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# Proxy server configurations to be used with the HTTP client endpoint.
public type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

# OAuth2 Refresh Token Grant Configs
public type OAuth2RefreshTokenGrantConfig record {|
    *http:OAuth2RefreshTokenGrantConfig;
    # Refresh URL
    string refreshUrl = "http://UAA_DOMAIN/oauth/token";
|};

public type Group record {
    string display;
    string 'type?;
    string value?;
};

# Name object can be null. Example: "name": {}. Name attributes are fetched from WebKey during authentication.
public type ScimUserPut record {
    # False means a soft delete.
    boolean active?;
    # Name request
    NameRequest name;
    # The e-mail address of the user.
    UserName userName;
    # An array of emails
    Email[] emails;
    # An array of subtenants.
    SubtenantId[] subtenants?;
};

public type ScimMeta record {
    string created?;
    string lastModified?;
    int 'version?;
};

public type Email record {
    # The email address.
    string value;
};

# The e-mail address of the user.
public type UserName string;

public type ScimUserResponse record {
    string[] schemas?;
    string id?;
    # The e-mail address of the user.
    string userName?;
    NameResponse name?;
    Group[] groups?;
    Email[] emails?;
    boolean active?;
    ScimMeta meta?;
    SubtenantId[] subtenants?;
};

public type SubtenantId record {
    # The ID / name of the subtenant.
    string id;
};

public type OAuthClient record {
    # Identifier of the client, unique within the identity zone
    string clientId?;
    # List of grant types that can be used to obtain a token with this client. Can include authorization_code, password, implicit, and/or client_credentials.
    string[] authorizedGrantTypes?;
    string[] redirectUri?;
    # A human readable name for the client
    string name?;
    # Scopes which the client is able to grant when creating a client. Defaults to "uaa.none". E.g. with client_credentials as authorized_grant_types, the client will get the scopes listed here.
    string[] authorities?;
    # Scopes allowed for the client. Defaults to "uaa.none". E.g. with *password* as authorized_grant_types the user can get the intersection of his scopes and the scopes listed here.
    string[] scopes?;
    # Epoch (milliseconds) of the moment the client information was last altered. Not affected by secret changes.
    int lastModified?;
    # Epoch (milliseconds) of the moment the client secret was introduced. Array contains creation times in ascending order.
    # Most of the time it should contain only one item, except during secret rotation - in that case, two items will be there.
    ClientSecretCreationTimes secretCreationTimes?;
};

# Name request
public type NameRequest record {
    # Family name
    string familyName;
    # Given name
    string givenName;
};

public type ScimGroupPost record {
    # Human readable description of the group, displayed e.g. when approving scopes
    string description?;
    # The identifier specified upon creation of the group, unique within the identity zone
    string displayName;
    # If given members array is empty, all members will be deleted.
    ScimGroupMember[] members?;
};

public type ScimGroupMember record {
    # Either "USER" or "GROUP"
    string 'type;
    # Globally unique identifier of the member, either a user ID or another group ID
    string value;
};

# Epoch (milliseconds) of the moment the client secret was introduced. Array contains creation times in ascending order.
# Most of the time it should contain only one item, except during secret rotation - in that case, two items will be there.
public type ClientSecretCreationTimes int[];

public type NameResponse record {
    string familyName?;
    string givenName?;
};

public type ScimUserResponseSearchResults record {
    int itemsPerPage?;
    ScimUserResponse[] resources?;
    string[] schemas?;
    int startIndex?;
    int totalResults?;
};

public type ChangedSecretResponse record {
    # the new secret.
    string secret?;
};

public type ScimGroupMemberList ScimGroupMember[];

public type ScimGroupSearchResults record {
    int itemsPerPage?;
    ScimGroup[] resources?;
    string[] schemas?;
    int startIndex?;
    int totalResults?;
};

public type ScimGroup record {
    # The globally unique group ID
    string id?;
    # Human readable description of the group, displayed e.g. when approving scopes
    string description?;
    # The identifier specified upon creation of the group, unique within the identity zone
    string displayName?;
    ScimGroupMember[] members?;
    ScimMeta meta?;
};

public type ChangeSecretRequest record {
    # New secret for the client. Must meet the following requirements:
    #   * alphabet is a-zA-Z0-9
    #   * minimum 43 characters
    #   * maximum 255 characters
    # If parameter is missing, then new secret will be generated.
    string newSecret?;
};

public type ScimUserPost record {
    # False means a soft delete.
    boolean active?;
    # Name request
    NameRequest name?;
    # The e-mail address of the user.
    UserName userName;
    SubtenantId[] subtenants?;
};

public type ScimUserPostResponse record {
    string[] schemas?;
    string id?;
    # The e-mail address of the user.
    string userName?;
    NameResponse name?;
    Group[] groups?;
    Email[] emails?;
    boolean active?;
    ScimMeta meta?;
    SubtenantId[] subtenants?;
};
