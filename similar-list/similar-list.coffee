if Meteor.isClient
    @simSearch = new Spomet.Search()
    @simSearch.setIndexNames ['custom']

    Template.similarsList.similars = () ->
        simSearch.results()