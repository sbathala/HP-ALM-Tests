*** Settings ***
Documentation     The final result of test execution is determined based on critical tests. If a single critical test fails, the whole test run is considered failed. On the other hand, non-critical test cases can fail and the overall status is still considered passed.
...
...               All test cases are considered critical by default, but this can be changed with the --critical (-c) and --noncritical (-n) options. These options specify which tests are critical based on tags, similarly as --include and --exclude are used to select tests by tags. If only --critical is used, test cases with a matching tag are critical. If only --noncritical is used, tests without a matching tag are critical. Finally, if both are used, only test with a critical tag but without a non-critical tag are critical.
Suite Teardown    Run Keyword If All Critical Tests Passed    log    Success, all critical tests passed.
Library           ../Workspace/TautCore/Libraries/Platform/TA5K/Ta5k.py

*** Variables ***
${a}              1
${b}              1
@{L}              ONE    2    Three    4    5

*** Test Cases ***
Run Keyword
    [Documentation]    Executes the given keyword with the given arguments.
    [Tags]    tag1
    Run Keyword    simple_user_defined_keyword
    [Teardown]    Run Keyword If Test Passed    log    This test passed successfully.

Run Keyword And Expect Error
    [Documentation]    Runs the keyword and checks that the expected error occured.
    Run Keyword And Expect Error    1 != 2    Should Be Equal As Integers    1    2
    ${msg}=    Run Keyword And Expect Error    string1 != string 2    Should Be Equal As Strings    string1    string 2
    log    ${msg}

Run Keyword And Ignore Error
    [Documentation]    Runs the given keyword with the given arguments and ignores possible error.
    ...
    ...
    ...    This keyword returns *TWO* values, so that the first is either string *PASS or FAIL*, depending on the status of the executed keyword. The second value is either the *return value of the keyword or the received error message*.
    Run Keyword And Ignore Error    user_defined_keyword_to_generate_error

Run Keyword If
    [Documentation]    Runs the given keyword if the condition is true.
    Run Keyword If    ${a}==1    simple_user_defined_keyword
    Run Keyword If    ${a}==0    user_defined_keyword_to_FAIL

Run Keyword And Return Status
    [Documentation]    Runs the given keyword with given arguments and returns the status as a boolean value.
    ${ret}=    Run Keyword And Return Status    Should Be Equal    a    a

Run Keyword Unless
    [Documentation]    Runs the given keyword if the condition is false.
    Run Keyword Unless    ${a}>${b}    simple_user_defined_keyword
    Run Keyword Unless    ${a}==${b}    user_defined_keyword_to_FAIL

Run Keywords
    [Documentation]    Executes all the given Keywords in a sequence.
    Run Keywords    simple_user_defined_keyword    user_defined_keyword_to_get_count

Continue For loop
    [Documentation]    Skips the current loop iteration and continues from next.
    : FOR    ${i}    IN    one    two    three
    \    Continue For Loop
    \    fail    Will not execute.
    Should Be Equal    ${i}    three
    log    ${i}

Continue For Loop If
    [Documentation]    Skips the current loop iteration if the condition is true.
    : FOR    ${i}    IN    1    2
    \    Continue For Loop If    ${i}<3
    \    fail    Will not execute.
    log    ${i}

Exit For Loop
    [Documentation]    Exits the enclosing for loop and continues execution after it.
    : FOR    ${i}    IN    exit    enter
    \    Run Keyword If    ${i}==exit    Exit For Loop
    \    fail    Will not execute.
    log    Out of For Loop

*** Keywords ***
simple_user_defined_keyword
    log    This is an example to 'Run Keyword'

user_defined_keyword_to_FAIL
    Fail    Expected Failure

user_defined_keyword_to_generate_error
    Should Be Equal As Strings    string 1    string 2

user_defined_keyword_to_pass
    ${MSG}=    Should Be Equal    1    1

user_defined_keyword_to_get_count
    getcount    1 2 3 4 5 6 7 8 9 10 11 12 13 14 15    1

check
