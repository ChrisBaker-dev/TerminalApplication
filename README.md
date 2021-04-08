# Christopher Baker - T1A3 Terminal Application

## Description
This application is a finance application designed to help people who wish to learn more about trading on a stock market. It allows users to:

    1. Create a profile to trade with
    2. View stock information (ex. prices, market change, news)
    3. Execute trades
    4. Track stock portfolio growth
    5. 


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

## Target Audience
This application is intended for anyone who wishes to learn more about trading and the financial world. You will be able to implement your own trading techniques, track your own growth and learn about the financial market. There is no required investment for this application, you will be trading fake money.

## How to use
First, you must install all the requried Ruby gems.

Second, you must go to the IEX website (link provided) and create a free or paid account to receive an API key in order to access financial data.

Now you are ready to load the application.
Upon loading the application, you will be able to select from already created profiles or create your own from scratch. 

From there, your trading journey will begin. I'd recommend looking through the various menus and selecting the help option to guide you through what they accomplish.
