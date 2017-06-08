# prettier-greenkeeper

Run prettier every time a new version is published to ensure the most recent code style.

## Prerequisites
- You use Travis CI and have it build Pull Requests (default behaviour)
- You have `prettier` installed as a (dev-)dependency for your project

## Getting started

### Key

In order to enable Travis CI to push to our repository, it needs an access token. You can create one [here](https://github.com/settings/tokens/new) (select `repo` and write down the token, GitHub won't show you again!). Now we need to tell Travis about it, there's two ways to do this:

#### Via Web Interface

This access token can be added as an environment variable to Travis CI using the web interface, which means we don't have to put it into some file and encrypt it manually. Go to the Travis CI website, to your project, click options, and create a new environment variable called `PUSH_TOKEN` which will contain our newly generated token.

#### Via .travis.yml

**Alternatively**, you can encrypt the token and put it right into the `.travis.yml`. In order to do this, install the Travis command line tool (`gem install travis`, requires Ruby and Gem being installed), and then run this command **inside the directory of your repository**:
```
travis encrypt PUSH_TOKEN=PUTYOURTOKENHERE
```
This will generate a string. Copy it and place it inside the `.travis.yml`:
```
secure: YOURFANCYSTRINGHERE
```

More info on encrypted keys in Travis [here](https://docs.travis-ci.com/user/encryption-keys/).

### Code

Firstly, you add this part to your `.travis.yml`:
```yml
after_success:
  - curl -s https://raw.githubusercontent.com/lgeiger/prettier-greenkeeper/master/travis.sh | sh
```

It tells Travis that once the build has succeeded, it's supposed to download and execute `travis.sh`, which will do the main work. It runs prettier and then pushes those changes to the branch of the Pull Request.

If you want to customize prettier, add a `npm` script called `prettier` to your `package.json` file and `travis.sh` will run it instead:

```json
"scripts": {
  "prettier": "prettier --write 'lib/**/*.js' 'spec/**/*.js'",
}
```

**Note**: Prettier runs only if:
- the branch name includes "greenkeeper"
- the most recent commit at runtime has "chore(package): update" in its name
