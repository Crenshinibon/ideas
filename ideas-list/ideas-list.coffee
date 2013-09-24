if Meteor.isClient
    Template.ideasListControl.searchFieldConf =
        fieldSizeClass: 'span8'
        buttonText: 'Find!'
    
    Meteor.subscribe 'ideas'
    
    Template.ideasList.ideas = () ->
        Ideas.find()

if Meteor.isServer
    Meteor.publish 'ideas', () ->
        Ideas.find()