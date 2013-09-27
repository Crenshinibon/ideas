if Meteor.isClient
    Template.ideasListControl.searchFieldConf =
        fieldSizeClass: 'span8'
        buttonText: 'Find!'
    
    Template.newIdeasList.ideas = () ->
        NewIdeas.find()
    
    Template.ideasList.searching = () ->
        Spomet.defaultSearch.getCurrentPhrase()?
    
    Template.ideasList.results = () ->
        Spomet.defaultSearch.results()
    
    Template.ideasList.ideas = () ->
        Ideas.find()
    
    Session.setDefault 'sort-by', 'changed'
    Session.setDefault 'sort-dir', -1
    
    updateList = () ->
        sortBy = Session.get 'sort-by'
        sortDir = Session.get 'sort-dir'
        sort = {}
        sort[sortBy] = sortDir
        
        if Spomet.defaultSearch.getCurrentPhrase()?
            Spomet.defaultSearch.setSort sort
        else
            reSubscribe sort
    
    toggleSortDir = () ->
        sortDir = Session.get 'sort-dir'
        if sortDir is -1
            Session.set 'sort-dir', 1
        else
            Session.set 'sort-dir', -1
    
    sortKeys = 
        Score: 'score'
        Date: 'changed'
        Title: 'title'
        
    Template.ideasListSort.sortDesc = () ->
        if (Session.get 'sort-dir') is -1
            'icon-white'
    
    Template.ideasListSort.sortAsc = () ->
        if (Session.get 'sort-dir') is 1
            'icon-white'
        
    Template.ideasListSort.options = () ->
        sortedBy = Session.get 'sort-by'
        if Spomet.defaultSearch.getCurrentPhrase()?
            Session.set 'sort-by', 'score'
            [{name: 'Score', selected: 'selected'}]
        else
            if sortedBy is 'score'
                sortedBy = 'changed'
                Session.set 'sort-by', sortedBy
            [{name: 'Date', selected: if sortedBy is 'changed' then 'selected'}
            {name: 'Title', selected: if sortedBy is 'title' then 'selected'}]
            
    Template.ideasListSort.events
        'change select': (e) ->
            sorted = $(e.target).val()
            Session.set 'sort-by', sortKeys[sorted]
            updateList()
        'click button.sort-direction': (e) ->
            e.preventDefault()
            toggleSortDir()
            updateList()
    
    Template.ideasListHeader.events
        'click button.new-button': (e) ->
            NewIdeas.insert 
                title: 'New Idea'
                description: ''
                