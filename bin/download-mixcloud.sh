#!/bin/sh
youtube-dl --add-metadata --embed-thumbnail --external-downloader wget --external-downloader-args '-c --tries=0 --read-timeout=0.5' "$1"
