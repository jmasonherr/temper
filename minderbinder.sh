!#/bin/bash
su - pi -c "screen -dm -S pistartup ~/temper"

sudo meteor mongo --url temper.meteor.com > urlfile.txt
sudo meteor
