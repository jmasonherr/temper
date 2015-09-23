
# # mongo url gotten by meteor mongo --url
# #[ WHITE:'28-00000651dea5', BLACK:'28-00000688662f' ]
# if process.env.USER == 'pi' or process.env.USER == 'root'
#     console.log 'STARTING AS PI'

Meteor.startup ->
    if not Machines.findOne
        console.log 'NO MACHINES AT STARTUP'
        white = Machines.insert # Original machine
            _id: '28-00000651dea5'
            pin: 18
            name: 'Xochipilli'
            user: 'dy8TuaSZxqH6CoYsE'
        black = Machines.insert # New machine
            _id: '28-00000688662f'
            pin: 15
            name: 'Xochiquetzal'
            user: 'dy8TuaSZxqH6CoYsE'
