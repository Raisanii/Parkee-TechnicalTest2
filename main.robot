*** Settings ***
Library           RequestsLibrary
Library           OperatingSystem
Library           Collections

*** Variables ***
${BASE_URL}       https://reqres.in
${AVATAR_FILE}    image.png
${REQUEST_BODY}   {"email": "raisani@example.com", "firs_name": "Rai", "last_name": "Sani"}

*** Test Cases ***
[POSITIF CASE] Add User
    [Documentation]  Verify status code is 201 for positive case add user
    Create Session  reqres  ${BASE_URL}
    ${headers}=     Create Dictionary  Content-Type=multipart/form-data
    ${data}=  Evaluate  json.loads('''${REQUEST_BODY}''')
    ${file_data}=   Create Dictionary  file=@${AVATAR_FILE}
    Set To Dictionary  ${data}  avatar  ${file_data}
    ${response}=    POST On Session  reqres  /api/users  data=${data}  headers=${headers}
    Should Be Equal As Strings  ${response.status_code}  201
    Run Keyword If  '${response.status_code}' != '201'
    ...  Fail  Expected status code 400 but got ${response.status_code}
    ...  ELSE
    ...  Set Test Message  Status code is 201
    Set Suite Variable  ${response}

[NEGATIF CASE] Missing Request Body Fields
    [Documentation]  Verify status code is 400 for Missing Request Body Fields
    Create Session  reqres  ${BASE_URL}
    ${headers}=     Create Dictionary  Content-Type=multipart/form-data
    ${data}=        Create Dictionary
    ${response}=    POST On Session  reqres  /api/users  data=${data}  headers=${headers}
    Run Keyword If  '${response.status_code}' == '201'
    ...  Fail  Expected status code 400 but got ${response.status_code}
    ...  ELSE
    ...  Set Test Message  Status code is 400
    Set Suite Variable  ${response}

[NEGATIF CASE] Missing Response
    [Documentation]  Verify response not missing
    Create Session  reqres  ${BASE_URL}
    ${headers}=     Create Dictionary  Content-Type=multipart/form-data
    ${data}=        Evaluate  json.loads('''${REQUEST_BODY}''')
    ${file_data}=   Create Dictionary  file=@${AVATAR_FILE}
    Set To Dictionary  ${data}  avatar  ${file_data}
    ${response}=    POST On Session  reqres  /api/users  data=${data}  headers=${headers}
    Run Keyword If  '${response.text}' == ''
    ...  Fail  Response is empty
    ...  ELSE
    ...  Set Test Message  Response is not empty  ${response.text}
    Set Suite Variable  ${response}

[NEGATIF CASE] Response Equals Request
    [Documentation]  Verify response is equals request
    Create Session  reqres  ${BASE_URL}
    ${headers}=     Create Dictionary  Content-Type=multipart/form-data
    ${data}=        Evaluate  json.loads('''${REQUEST_BODY}''')
    ${file_data}=   Create Dictionary  file=@${AVATAR_FILE}
    Set To Dictionary  ${data}  avatar  ${file_data}
    ${response}=    POST On Session  reqres  /api/users  data=${data}  headers=${headers}
    ${response_data}=  Set Variable  ${response.json()}
    Run Keyword If    ${response_data} != ${data}
    ...  Fail  Response does not equal request
    ...  ELSE
    ...  Set Test Message  Response is equals request