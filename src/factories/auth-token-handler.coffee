# =============================================================================
# Copyright (c) 2013 All Right Reserved, http://starqle.com/
#
# This source is subject to the Starqle Permissive License.
# Please see the License.txt file for more information.
# All other rights reserved.
#
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
# KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
# PARTICULAR PURPOSE.
#
# @file_name src/factories/auth-token-handler.coffee
# @author Giovanni Sakti
# @email giosakti@starqle.com
# @company PT. Starqle Indonesia
# @note This file contains AuthTokenHandler for wrapping API calls with
#   AuthToken.
# =============================================================================


angular.module('auth.token.handler',[]).factory "AuthTokenHandler", [ ->
  authTokenHandler = {}
  username = "none"
  authToken = "none"
  ip_location = "none"

  # Getter / setter
  authTokenHandler.getUsername = () ->
    return username
  authTokenHandler.getAuthToken = () ->
    return authToken
  authTokenHandler.getIpLocation = () ->
    return ip_location
  authTokenHandler.setUsername = (newUsername) ->
    username = newUsername
    return
  authTokenHandler.setAuthToken = (newAuthToken) ->
    authToken = newAuthToken
    return
  authTokenHandler.setIpLocation = (newIpLocation) ->
    ip_location = newIpLocation
    return

  # Wrap every actions in a resource with tokenWrapper function
  # Returns wrappedResource
  authTokenHandler.wrapActions = (resource, actions) ->
    console.log 'test', resource
    wrappedResource = resource

    i=0
    while i < actions.length
      tokenWrapper wrappedResource, actions[i]
      i++

    wrappedResource

  # Wrap an action in a resource with authn_token
  # Treat each kind of action accordingly
  tokenWrapper = (resource, action) ->
    resource['_' + action] = resource[action]

    if action in ['save', 'update']
      resource[action] = (params, data, success, error) ->
        resource['_' + action] angular.extend({}, params or {},
          username: authTokenHandler.getUsername()
          authn_token: authTokenHandler.getAuthToken()
          HTTP_X_REAL_IP: authTokenHandler.getIpLocation()
        ), data, success, error
    else
      resource[action] = (params, success, error) ->
        resource["_" + action] angular.extend({}, params or {},
          username: authTokenHandler.getUsername()
          authn_token: authTokenHandler.getAuthToken()
          HTTP_X_REAL_IP: authTokenHandler.getIpLocation()
        ), success, error

    return


  return authTokenHandler


]
