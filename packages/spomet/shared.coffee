Spomet = {}

Spomet.Searches = new Meteor.Collection 'spomet-search'
Spomet.CommonTerms = new Meteor.Collection 'spomet-fullword'

Spomet.options =
    indexes: []
    resultsCount: 20
    keywordsCount: 1000
    sort:
        field: 'score'
        direction: -1

Spomet.phraseHash = (phrase) ->
    CryptoJS.MD5(phrase).toString()

Spomet._docId = (docSpec) ->
    unless docSpec.version? then docSpec.version = 1
    unless docSpec.type? then docSpec.type = 'default'
    unless docSpec.path? then docSpec.path = '/'
    
    docSpec.type + '-' + docSpec.base + '-' + docSpec.path + '-' + docSpec.version
    
Spomet.buildSearchQuery = (options) ->
    phraseHash = CryptoJS.MD5(options.phrase).toString()
    selector = {phraseHash: phraseHash}
    
    if options.excludes?
        selector.base = {$nin: options.excludes}
    
    unless options.sort?
        options.sort = Spomet.options.sort
    
    qOpts = {}
    qOpts.sort = {}
    qOpts.sort[options.sort.field] = options.sort.direction
    
    if options.offset?
        if options.sort.direction is -1
            selector[options.sort.field] = {$lte: options.offset}
        else if options.sort.direction is 1
            selector[options.sort.field] = {$gte: options.offset}
    
    if options.limit? 
        qOpts.limit = options.limit
    else
        qOpts.limit = Spomet.options.resultsCount
    [selector, qOpts]

@Index = {}
