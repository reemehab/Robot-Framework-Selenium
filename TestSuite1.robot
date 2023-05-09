*** Settings ***
Library           SeleniumLibrary
Library           Collections

*** Variables ***
${Sleep Time}     2
${Advanced Search}    ${EMPTY}
${StartYear}      2010
${EndYear}        2020

*** Test Cases ***
TestCase3
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Maximize Browser Window
    wait until page contains Element    id=suggestion-search
    Click Element    css=label.ipc-btn[aria-label="All"]
    Sleep    ${Sleep Time}
    ${Advanced Search} =    Get WebElement    xpath://span[contains(@class, 'ipc-list-item__text') and text()='Advanced Search']
    Click Element    ${Advanced Search}
    Wait Until Page Contains Element    xpath://*[@id="header"]/h1
    Click Element    //a[contains(text(),'Advanced Title Search')]
    Wait Until Page Contains Element    //*[@id="header"]/h1
    Scroll Element Into View    //*[@id="title_type-1"]
    Select Checkbox    //*[@id="title_type-1"]
    Scroll Element Into View    //*[@id="genres-1"]
    Select Checkbox    //*[@id="genres-1"]
    Sleep    ${Sleep Time}
    input text    name=release_date-min    ${StartYear}
    Sleep    ${Sleep Time}
    input text    name=release_date-max    ${EndYear}
    Sleep    ${Sleep Time}
    Scroll Element Into View    //*[@id="main"]/p[3]/button
    Click Button    //*[@id="main"]/p[3]/button
    wait until page contains Element    //*[@id="main"]/div/h1
    Click Element    //*[@id="main"]/div/div[2]/a[3]
    Sleep    ${Sleep Time}
    @{Rating_values}=    Create List
    ${elements}=    Get WebElements    xpath=//div[@class="inline-block ratings-imdb-rating"]
    FOR    ${element}    IN    @{elements}
        ${Rating_value}=    get text    ${element}
        Append To List    ${Rating_values}    ${Rating_value}
    END
    Log List    ${Rating_values}
    ${copied_Ratings} =    Copy List    ${Rating_values}
    Sort List    ${copied_Ratings}
    reverse list    ${copied_Ratings}
    Log List    ${copied_Ratings}
    Lists Should Be Equal    ${copied_Ratings}    ${Rating_values}
    Sleep    ${Sleep Time}
    [Teardown]    Close Browser
