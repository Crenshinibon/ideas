calcMostCommonTermCount = (tokens) ->
    if tokens.length > 0
        currentMax = 1
        tCounts = {}
        tokens.forEach (t) ->
            if tCounts[t.token]?
                tCounts[t.token] += 1
                c = tCounts[t.token]
                if c > currentMax
                    currentMax = c
            else
                tCounts[t.token] = 1
        currentMax
    else
        0
    
@Documents = 
    collection: new Meteor.Collection 'spomet-docs'
    exists: (docSpec) ->
        existing = @collection.findOne docSpec
        existing?
    
    nextVersion: (docSpec) ->
        if docSpec.type? and docSpec.base? and docSpec.path?
            cur = @collection.find 
                    type: docSpec.type
                    base: docSpec.base
                    path: docSpec.path
                ,
                    sort: {version: -1}
                    limit: 1
                    
            res = cur.fetch()
            if res.length is 1
                res.version + 1
            else
                1
    
    get: (docId) ->
        @collection.findOne({docId: docId})
    
    query: (docSpec) ->
        results = []
        if docSpec?
            results = Spomet.Documents.collection.find(docSpec).fetch()
        results
        
    add: (docSpec, tokens) ->
        #expects as indexTokens {index: name, tokens: ['t1','t2']}
        unless @exists docSpec
            @collection.insert 
                docId: Spomet._docId docSpec
                text: docSpec.text
                type: docSpec.type
                base: docSpec.base
                path: docSpec.path
                version: docSpec.version
                dlength: docSpec.text.length
                created: new Date()
                indexTokens: tokens
                mostCommonTermCount: calcMostCommonTermCount tokens
            cMeta = @collection.findOne({meta: 'count'})
            if cMeta?
                @collection.update {_id: cMeta._id}, {$inc: {count: 1}}
            else
                @collection.insert {meta: 'count', count: 1}
    
    ratingParams: (docId) ->
        doc = @collection.findOne({docId: docId})
        if doc?
            dlength: doc.dlength
            mostCommonTermCount: doc.mostCommonTermCount
            documentsCount: @count()
        
    length: (docId) ->
        @collection.findOne({docId: docId})?.dlength
        
    mostCommonTermCount: (docId) ->
        @collection.findOne({docId: docId})?.mostCommonTermCount
        
    count: () ->
        @collection.findOne({meta: 'count'}).count
            
Spomet.Documents = @Documents