# Kadira.connect('mggXXtiNMT7Nzm9m7', '8f7af99a-a215-462e-b34a-303e656cadbf');


# Meteor.publish 'machines', ->
#     Machines.find({active: true}) # user: this.userId

# Meteor.publish 'latest', (machineId) ->
#     Runs.find
#         #user: this.userId,
#         machine: machineId,
#             sort:
#                 createdAt: -1
#             limit: 1

# Meteor.publish 'archive', ->
#     Runs.find user: this.userId,
#         sort:
#             createdAt: -1
#         limit: 20
