# wanderingsblog
www.weekendwanderings.com static website built using jekyll

## set up
### custom domain
- https://stackoverflow.com/questions/9082499/custom-domain-for-github-project-pages
- https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site

## resources
- https://github.com/captaincanine/marran.com
- https://shopify.github.io/liquid/basics/introduction/
- https://jekyllrb.com/docs/variables/
- [npm with jekyll](https://gwtrev.medium.com/how-the-f-do-i-add-a-js-pipeline-to-a-jekyll-website-you-ask-822a45ffb2cb)

## running locally : 
```bash
#Debug gh-pages locally with
act -s GITHUB_TOKEN=<base64 encoded> -s FLICKR_API_KEY=<base64 encoded> -s FLICKR_API_SECRET=<base64 encoded> --reuse
#run server locally with 
# window 1
bundle exec jekyll serve --livereload --trace
# window 2
npm run watch:scripts
```

## Debugging jekyl performance : 
```bash
be jekyll build --profile --verbose
```
- https://cloudcannon.com/blog/speed-up-your-jekyll-builds
- https://blog.mastykarz.nl/improve-jekyll-setup/
- https://github.com/benbalter/jekyll-include-cache

## jekyll compose
```bash
bundle exec jekyll page "My New Page"

draft      # Creates a new draft post with the given NAME
post       # Creates a new post with the given NAME
publish    # Moves a draft into the _posts directory and sets the date
unpublish  # Moves a post back into the _drafts directory
page       # Creates a new page with the given NAME
rename     # Moves a draft to a given NAME and sets the title
compose    # Creates a new file with the given NAME
```
