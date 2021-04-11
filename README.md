# Christopher Baker - T1A3 Terminal Application


## References
### iex-ruby-client 
iex-ruby-client is a gem used to connect with the IEX cloud API. 
https://github.com/dblock/iex-ruby-client


## Description
This application is a finance application designed to help people who wish to learn more about trading on a stock market. It allows users to:

    1. Create a profile to trade with
    2. View stock information (ex. prices, market change, news)
    3. Execute trades

## Source Control Respository
https://github.com/ChrisBaker-dev/TerminalApplication



## Required Libraries
### TTY-Prompt
TTY-Prompt is going to make the users life easier while navigating the application. It speeds up our processes so the user does not need to type each command. Example, instead of needing to type "login", you will able to select login as an option from the prompt.
```ruby
gem install tty-prompt
```

### TTY-Table
TTY-Table is going to allow us to show you information with greater readability.
```ruby
gem install tty-table
```

### IEX Ruby Client
IEX Ruby Client allows us to access the IEX API. IEX is a cloud finance company that gives current information on all stock requests.
```ruby
gem install iex-ruby-client
```

### JSON
JSON generally comes pre installed with your ruby environment, but just incase you do not have it, please install it. JSON will allow us to store data for our profiles so we can track information and learn more about our financial trades.
```ruby
gem install json
```

## What will this application do?
This application will allow people to create a profile and allot a sum of money to invest with. The user will then begin trading in their desired stocks and can track their profiles growth and stock values over time.

## What problem am I solving and why develop it?
I created this software for a couple reasons. First, understanding the stock market and executing trades can seem daunting at first glance. This application aims to allow people to learn without financial risk or, for those who are looking to test new investment strategies, test those strategies without risk. 

## Target Audience
This application is intended for anyone who wishes to learn more about trading and the financial world. You will be able to implement your own trading techniques, track your own growth and learn about the financial market. There is no required investment for this application, you will be trading fake money.

## How to use
First, you must install all the requried Ruby gems.

Second, you must go to the IEX website (link provided) and create a free or paid account to receive an API key in order to access financial data.

Now you are ready to load the application.
Upon loading the application, you will be able to select from already created profiles or create your own from scratch. 

From there, your trading journey will begin. I'd recommend looking through the various menus and selecting the help option to guide you through what they accomplish.

## Features
This applications comes with three main features:
1. Profile Creation
2. Execution of trades (buy/sell)
3. Profile/Investment summaries

### Profile Creation
Profile creation is important to the user because it allows them to track their performance over time. It also allows the user to test various investment techniques and save them individually so they can better understand the upsides or downsides. The user will decide upon launching the application to either load a profile or create a new one. 


## Implementation Plan
### Profile Creation
Checklist
1. Create/Save a profile class to store data
2. Create data structures to manage data
3. Create methods to display data to the user
4. Update profile class dependent on user inputs
5. Read and write to JSON file
6. Error Handling

### Execution of Trades (Buy/Sell)
Checklist
1. Create Stock class to manage data on the stock to trade
2. Connect communications with IEX API
    - Ensure key is valid
    - Get up to date stock information
3. Give feedback to user reguarding current prices
4. Process trade
    - Validate trade
    - Update profile data
    - Feedback to user
5. Error Handling

### Profile/Investment Summaries
Checklist
1. Update data to be displayed 

When viewing profile/investment summaries, the data needs to be updated to get current prices. Approximation of time needed to complete: 2 hours. Deadline: Friday April 10, 2021.

2. Create tables to display to user

In order to view the summaries better, I will create a table 

3. Make calculations to display to user
4. Utilize tty-table to format
5. Test outputs are correct

# Installation

Download and install Ruby onto your computer. Instructions on how to do so can be found here: [Ruby installation guide](https://www.ruby-lang.org/en/documentation/installation/ "Ruby installation")




## How to get an IEX API Key

1. Go to https://iexcloud.io/
2. Click Sign-in in the top right corner
![iex sign in](/docs/iex-sign-in.png)
3. Click create an account
4. Set account type to individual and complete your details
5. Agree to terms and conditions and click Create Account
6. You will be redirected to a page to choose a plan.
7. Scroll to the bottom of the page and select the free plan.
![iex free plan](/docs/iex-free-plan.png)
8. Verify your email address
    - They will require you to enter a 6 digit code emailed to you after you click the verify email link
9. You should now be on the main page for their site, if you try to refresh the page, it may have an error (on their end). If this happens, go to this URL: https://iexcloud.io/console/
10. Your screen should now look similar to this
![iex home](/docs/iex-home.png)
11. Click on API Tokens (Left side under Home)
12. Copy the publishable API Key
![iex key](/docs/iex-key.png)
13. You will use this key in order to run my application. If you have any errors, please return to your key and ensure you have copied it properly.
14. In order to save time in the application, follow these steps (if you have already ran followed the installation commands, if not please do so):

![src file](/docs/src-file.png)

    - Navigate to to the applications source folder
    - type echo "YOUR API KEY HERE" >> .env
    - Hit enter
15. You should now see your API key in the .env file and the application will not ask you to manually enter it
16. Happy Trading!
