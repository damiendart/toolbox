#!/usr/bin/env python

"""A dynamic-DNS thing for NearlyFreeSpeech.NET-managed domains.

This file was written by Damien Dart, <damiendart@pobox.com>. This is
free and unencumbered software released into the public domain. For more
information, please refer to the accompanying "UNLICENCE" file.
"""

import hashlib
import json
import random
import string
import time
import urllib2

class NFSNAPIRequest():
  """An abstraction of a NearlyFreeSpeech.NET API request.

    - "username" should be a string containing the member login name of
      the user making the request.
    - "API_key" should be a string containing the API key assosiated
      with the member login name; an API key can be obtained by
      submitting a secure support request to NearlyFreeSpeeech.NET.
    - "request_path" should be a string containing the path portion of
      the requested URL. For example, if the requested URL is
      <https://api.nearlyfreespeech.net/site/example/addAlias>,
      "request_path" would be "/site/example/addAlias".
    - "request_body" may be a string containing the HTTP request body,
      or "None" if no such data is required.
  """

  def __init__(self, username, API_key, request_path, request_body = None):
    self.API_key, self.username = API_key, username
    self.request_body, self.request_path = request_body, request_path

  def run(self):
    """Runs the request and returns the response as a string.

    The NearlyFreeSpeech.net API documentation is unclear on whether
    every successful API call returns a valid JSON-encoded associative
    array, hence why any response is returned as a string. This method
    raises "NFSNAPIRequestError" on errors.

    NOTE: As this method uses the "urllib2.urlopen" function to run
    requests, the API server's certificate is not verified.
    """
    salt = "".join(random.choice(string.ascii_letters) for i in range(16))
    timestamp = str(int(time.time()))
    try:
      return urllib2.urlopen(
          urllib2.Request("https://api.nearlyfreespeech.net%s"
          % self.request_path, self.request_body, {"X-NFSN-Authentication" :
          ";".join([self.username, timestamp, salt, hashlib.sha1(";".join(
          [self.username, timestamp, salt, self.API_key, self.request_path,
          hashlib.sha1(self.request_body).hexdigest()])).hexdigest()])})).read()
    except urllib2.HTTPError as e:
      try:
        error_response = json.loads(e.read())
        raise NFSNAPIRequestException(e.code, error_response["error"],
            error_response["debug"])
      except ValueError:
        raise NFSNAPIRequestException(e.code, e.response, "")


class NFSNAPIRequestError(Exception):
  """Raised when an NearlyFreeSpeech.NET API request fails."""

  def __init__(self, error_code, error_message, debug_message):
    Exception.__init__(self, error_message)
    self.debug_message = debug_message
    self.error_code, self.error_message = error_code, error_message


if __name__ == "__main__":
  import sys
  try:
    # TODO: Check if IP addresses are being returned.
    old_ip_address = json.loads(NFSNAPIRequest(sys.argv[1], sys.argv[2],
        "/dns/%s/listRRs" % sys.argv[3], "name=%s" % sys.argv[4]).run())[0]["data"]
    new_ip_address = urllib2.urlopen("http://icanhazip.com").read().rstrip()
    if (old_ip_address == new_ip_address):
      print "IP address hasn't changed, no further action is required."
    else:
      NFSNAPIRequest(sys.argv[1], sys.argv[2],
          "/dns/%s/removeRR" % sys.argv[3],
          "name=%s&type=A&data=%s" % (sys.argv[4], old_ip_address)).run()
      NFSNAPIRequest(sys.argv[1], sys.argv[2],
          "/dns/%s/addRR" % sys.argv[3],
          "name=%s&type=A&data=%s&ttl=180" % (sys.argv[4], new_ip_address)).run()
      print "<http://%s.%s/> now points to %s." % (sys.argv[4], sys.argv[3],
          old_ip_address)
  except NFSNAPIRequestError as e:
    print "ERROR: " + str(e)
