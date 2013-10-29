@Ideas = new Meteor.Collection 'ideas'

if Meteor.isClient
    @NewIdeas = new Meteor.Collection null
    
    handle = null
    @reSubscribe = (sort) ->
        if handle?
            handle.stop()
            
        handle = Meteor.subscribe 'ideas', sort
    
    reSubscribe()

if Meteor.isServer
    
    Meteor.publish 'ideas', (sort) ->
        unless sort?
            sort = {}
            sort.changed = -1
        Ideas.find {}, {sort: sort, limit: 20}
    
    
    if Meteor.users.find({username: 'test1'}).count() is 0
        Accounts.createUser
            username: 'test1'
            password: 'test1'
    if Meteor.users.find({username: 'test2'}).count() is 0
        Accounts.createUser
            username: 'test2'
            password: 'test2'
    if Ideas.find().count() is 0
        #texts are borrowed from http://en.wikipedia.org/wiki/Idea
        console.log 'Creating sample ideas'
        idea1 =    
            user: 'test1'
            title: 'Nature of ideas'
            description: 'One view on the nature of ideas is that there exist some ideas (called innate ideas) which are so general and abstract, that they could not have arisen as a representation of any object of our perception, but rather were, in some sense, always in the mind before we could learn them. These are distinguished from adventitious ideas which are images or concepts which are accompanied by the judgment that they are caused or occasioned by some object outside of the mind.'
            changed: new Date((new Date()).getTime() - 1*24*60*60*1000)
            votes: []
            votesCount: 0
        id1 = Ideas.insert idea1
        Spomet.add 
            text: idea1.description
            path: 'description'
            base: id1
            type: 'idea'
        Spomet.add 
            text: idea1.title
            path: 'title'
            base: id1
            type: 'idea'
        
        idea2 =
            user: 'test1'
            title: 'Another view of ideas'
            description: 'Another view holds that we only discover ideas in the same way that we discover the real world, from personal experiences. The view that humans acquire all or almost all their behavioral traits from nurture (life experiences) is known as tabula rasa ("blank slate"). Most of the confusions in the way of ideas arise at least in part from the use of the term "idea" to cover both the representation percept and the object of conceptual thought. This can be illustrated in terms of the doctrines of innate ideas, "concrete ideas versus abstract ideas", as well as "simple ideas versus complex ideas"'
            changed: new Date(new Date((new Date()).getTime() - 2*24*60*60*1000))
            votes: []
            votesCount: 0
        id2 = Ideas.insert idea2
        
        Spomet.add 
            text: idea2.description
            path: 'description'
            base: id2
            type: 'idea'
        Spomet.add
            text: idea2.title
            path: 'title'
            base: id2
            type: 'idea'
        
        idea3 =
            user: 'test2'
            title: 'Haque\'s theory'
            description: 'However, Md. Ziaul Haque, a poet, columnist, scholar, researcher and a faculty member at Sylhet International University, Bangladesh, has invented a term viz, prosaic-ideas keeping in mind that our thoughts are not poetic but prosaic in general. In other words, “...thinking is translating ‘prosaic-ideas’ without accessories” since ideas (in brain) do not follow any metrical composition."'
            changed: new Date((new Date()).getTime() - 5*24*60*60*1000)
            votes: []
            votesCount: 0
        id3 = Ideas.insert idea3
        Spomet.add 
            text: idea3.description
            path: 'description'
            base: id3
            type: 'idea'
        Spomet.add 
            text: idea3.title
            path: 'title'
            base: id3
            type: 'idea'
            