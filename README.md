# Evanston - Irkutsk weather comparison
> Because Evanston has become a virtual frozen wasteland

I created this project from [https://github.com/Monkeyanator/elm-gulp-boilerplate](this boilerplate project that I made). The same build steps should apply, so I lifted them from there to here.

## Build instructions

The boilerplate project here is lean and not intended to be extensible for all users. It uses various Gulp tasks to compile the Elm, minify and mash together the scss, and move static assets into `dist`.

The relevant Gulp tasks included are as follows:

* `gulp build-dev`: build non-optimized Elm and SCSS into `dist`
* `gulp build-prod`: build optimized and minified Elm and SCSS into `dist`
* `gulp watch`: watch for changes on Elm / SCSS sources and trigger rebuild on change