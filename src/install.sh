#!/bin/bash
echo "Cloning repository"
git clone "https://github.com/ChrisBaker-dev/TerminalApplication.git"
cd TerminalApplication/src
bundle install
touch .env
echo "IEXKEY=" >> .env
ruby main.rb