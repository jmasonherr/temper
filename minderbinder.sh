!#/bin/bash
sudo meteor mongo --url temper.meteor.com > urlfile.txt
screen -S tempering -dm sudo meteor
