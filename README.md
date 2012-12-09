# hn-api

The Hacker News API that you can GET.


## Why another API?

This API was created after a huge frustration with the [iHackerNews API](http://api.ihackernews.com/), which sadly at the time looks abandoned and also doesn't support authentication, which means you can't up vote or comment. This API is intended to be a successor of the iHN one. Open source, and with **authentication support**.


## Documentation

The little documentation of the API. It should be enough for a start.

### Sections

`GET /section/:name/:page/:number`

 - `name`: The name of the section ("home", "new", "ask")
 - `page` (Optional): Number of pages to retrieve
 - `number` (Optional): Desired page number

**Examples**

    GET /section/home        # Retrieves the front page feed
    GET /section/ask/2       # Retrieves the first two pages of the Ask HN feed
    GET /section/new/page/2  # Retrieves the second page of the New feed
