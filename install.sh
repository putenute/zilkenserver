#!/bin/bash

cp -r 1wire /var/
cp -r relais /var/
cp -r stromding /var/
cp -r www /var/
chown -R www-data:www-data /var/www/*
echo install done


