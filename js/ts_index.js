const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
    server: {
      apiKey: "LBP1jKMbL6c5W9pxr5raOOP790Pi7gJN", // Be sure to use an API key that only allows search operations
      nodes: [
        {
          host: "typesense.acdh-dev.oeaw.ac.at",
          port: "443",
          protocol: "https",
        },
      ],
      cacheSearchResultsForSeconds: 2 * 60, // Cache search results from server. Defaults to 2 minutes. Set to 0 to disable caching.
    },
    // The following parameters are directly passed to Typesense's search API endpoint.
    //  So you can pass any parameters supported by the search endpoint below.
    //  query_by is required.
    additionalSearchParameters: {
      query_by: "full_text"
    },
  });


const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
    indexName: 'bahr-static',
    searchClient,
});

search.addWidgets([
    instantsearch.widgets.searchBox({
        container: '#searchbox',
    }),

    instantsearch.widgets.hits({
        container: '#hits',
        templates: {
            empty: 'Keine passende Ergebnisse gefunden',
            item: `
                <h4> {{ id }}</h4>
                <h5><a href="{{ id }}.html">{{ title }}</a></h5>
                <p>{{#helpers.snippet}}{ "attribute": "full_text" }{{/helpers.snippet}}</p>
            `
        }
    }),

    instantsearch.widgets.stats({
        container: '#stats-container'
    }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-persons',
        attribute: 'persons',
        searchable: true,
    }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-places',
        attribute: 'places',
        searchable: true,
    }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-orgs',
        attribute: 'orgs',
        searchable: true,
    }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-works',
        attribute: 'works',
        searchable: true,
    }),

    instantsearch.widgets.pagination({
        container: '#pagination',
        padding: 2,
    }),

    instantsearch.widgets.clearRefinements({
        container: '#clear-refinements',
    }),

    instantsearch.widgets.currentRefinements({
        container: '#current-refinements',
    }),
      

    instantsearch.widgets.rangeInput({
        container: '#range-input',
        attribute: 'year',
        step: 10,
        pips: true,
    }),
      


]);



search.addWidgets([
    instantsearch.widgets.configure({
        attributesToSnippet: ['full_text'],
    })
]);


search.start();