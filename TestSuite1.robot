*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           BuiltIn

*** Variables ***
${Sleep Time}     2
${Advanced Search}    ${EMPTY}
${StartYear}      2010
${EndYear}        2020
${MovieName}      The Shawshank Redemption
${GenreAction}    action

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
    ${genre_elements} =    Get WebElements    xpath://span[@class="genre"]
    @{Genre_values}=    Create List
    FOR    ${element}    IN    @{genre_elements}
        ${genre_value}=    get text    ${element}
        Should Contain    ${genre_value}    ${GenreAction}    ignore_case=True
        Append To List    ${Genre_values}    ${genre_value}
    END
    Log List    ${Genre_values}
    Log    "All films are action"
    ${year_elements} =    Get WebElements    css=.lister-item-year.text-muted.unbold
    @{year_values}=    Create List
    FOR    ${element}    IN    @{year_elements}
        ${year_value}=    Get Element Attribute    ${element}    innerHTML
        ${year}    Set Variable    ${year_value.split("(")[-1].split(")")[0]}
        Append To List    ${year_values}    ${year}
    END
    Log List    ${year_values}
    FOR    ${year}    IN    @{year_values}
        Run Keyword If    ${year} not in range(2010, 2021)    Fail    "${year} is not in the range 2010-2020"
    END
    Log    "All years are between 2010 and 2020"
    [Teardown]    Close Browser

TestCase1
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Maximize Browser Window
    wait until page contains Element    id=suggestion-search
    input text    id=suggestion-search    ${MovieName}
    Sleep    ${Sleep Time}
    click element    id=iconContext-magnify
    Sleep    ${Sleep Time}
    Wait Until Page Contains Element    xpath://*[@id="__next"]/main/div[2]/div[3]/section/div/div[1]/section[1]/h1
    ${search_results} =    Get WebElements    class:ipc-metadata-list-summary-item__t
    FOR    ${result}    IN    @{search_results}
        Element Should Contain    ${result}    ${MovieName}    ignore_case=True
    END
    Element Text Should Be    xpath://*[@id="__next"]/main/div[2]/div[3]/section/div/div[1]/section[2]/div[2]/ul/li[1]/div[2]/div/a    ${MovieName}
    [Teardown]    Close Browser

TestCase2
    [Setup]    Open Browser    https://www.imdb.com/    Chrome
    Maximize Browser Window
    wait until page contains Element    id=suggestion-search
    click element    xpath://*[@id="iconContext-menu"]
    Sleep    ${Sleep Time}
    click element    xpath://*[@id="imdbHeader"]/div[2]/aside/div/div[2]/div/div[1]/span/div/div/ul/a[2]/span
    wait until page contains element    xpath://*[@id="main"]/div/span/div/div/div[3]/table/tbody/tr[106]/td[2]
    Sleep    ${Sleep Time}
    ${rating_elements} =    Get WebElements    xpath=//td[@class='ratingColumn imdbRating']//strong
    ${original_ratings}=    Create List
    FOR    ${rating_element}    IN    @{rating_elements}
        ${rating_attr}    get text    ${rating_element}
        append to list    ${original_ratings}    ${rating_attr}
    END
    ${copied_ratings}=    Copy List    ${original_ratings}
    Sort List    ${copied_ratings}
    reverse list    ${copied_ratings}
    Lists Should Be Equal    ${copied_ratings}    ${original_ratings}
    ${list_length} =    Get Length    ${original_ratings}
    Log    The length of my_list is ${list_length}
    Element Text Should Be    //*[@id="main"]/div/span/div/div/div[3]/table/tbody/tr[1]/td[2]/a    ${MovieName}
    Should Be Equal As Integers    ${list_length}    250
    [Teardown]    Close Browser
