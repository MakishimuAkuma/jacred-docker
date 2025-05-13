#!/bin/sh

if [ ! -f /app/config/init.conf ]; then
    cp /app/init.conf /app/config/init.conf
else
	yes | cp -rf /app/config/init.conf /app/init.conf
fi

./JacRed