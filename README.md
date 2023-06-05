# wanderingsblog
www.weekendwanderings.com static website built using jekyll

## set up
## very useful recipes for jekyl 
https://michaelcurrin.github.io/code-cookbook/recipes/ci-cd/github-actions/workflows/commit.html
### custom domain
- https://stackoverflow.com/questions/9082499/custom-domain-for-github-project-pages
- https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site

## resources
- AMAZING plugins : https://jekyllcodex.org/without-plugins/
- https://github.com/captaincanine/marran.com
- https://shopify.github.io/liquid/basics/introduction/
- https://jekyllrb.com/docs/variables/
- [npm with jekyll](https://gwtrev.medium.com/how-the-f-do-i-add-a-js-pipeline-to-a-jekyll-website-you-ask-822a45ffb2cb)

## use flickr tags to drive descriptions etc
- https://www.flickr.com/services/api/explore/flickr.photosets.getPhotos
### create albums with : 
#### 1 flickr image with tags js and main
#### jsu : update the post if provided
#### provide any other tags which will be fed to chatgpt to generate description for post
- https://platform.openai.com/docs/guides/chat/introduction


## on github : 
- https://github.com/gadzooks/wanderingsblog/settings/secrets/actions
- in the workflow file : .github/workflows/workflow.yml 

## running locally : 
```bash
# set these ENV variables
#Debug gh-pages locally with
act -s GITHUB_TOKEN=<GH_TOKEN> -s FLICKR_API_KEY=edc405009fa021ce9816f5a75dfe5801 -s FLICKR_API_SECRET=<secret> -s FLICKR_SHARED_SECRET=<secret> -s OPENAI_ACCESS_TOKEN=<chatgpt-token> --reuse
# window 1
export FLICKR_SHARED_SECRET=asdfasdf
export FLICKRAW_API_KEY=asdfasdf
export FLICKR_API_KEY=dfasdfk
export FLICKR_API_SECRET=asdfkas
export MONGO_USER=weekend-wandering-admin
export MONGO_PWD=secret
export MONGO_DB=weekend-wanderings-blog

bundle exec jekyll serve --livereload --trace
# window 2
npm run watch:scripts
```

# Jekyll docs
- https://devhints.io/jekyll
- liquid : https://shopify.github.io/liquid/filters/truncate/
- 

## running flick script locally
```bash
# export flickr secrets
./scripts/run-flickr-poll 
```

## flickr ruby API docs
- http://hanklords.github.io/flickraw/FlickRaw/ResponseList.html
- https://www.flickr.com/services/api/flickr.people.getPublicPhotos.htm

## mongo ruby docs : 
- https://www.rubydoc.info/gems/mongo/1.8.2/Mongo%2FCollection:find
- https://www.mongodb.com/docs/ruby-driver/master/tutorials/quick-start/#complete-sample-app

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
