gulp                   = require 'gulp'
coffee                 = require 'gulp-coffee'
uglify                 = require 'gulp-uglify'
concat                 = require 'gulp-concat'
sourcemaps             = require 'gulp-sourcemaps'
stylus                 = require 'gulp-stylus'
cleancss               = require 'gulp-cleancss'
filter                 = require 'gulp-filter'
notify                 = require 'gulp-notify'
nib                    = require 'nib'
path                   = require 'path'

js = [
  './project/assets/js/**/*.js',
  './project/assets/js/**/*.coffee',
]

css = [
  './project/assets/css/**/*.styl'
  './project/assets/css/**/*.css'
]

images = [
  './project/assets/images/**/*.*'
]

errorHandler = (name) ->
  return ->
    args = Array.prototype.slice.call arguments

    notify.onError
      title: name,
      message: '<%= error %>'
    .apply @, args

    @emit 'end'

gulp.task 'js', ->

  coffee_filter = filter '**/*.coffee'

  gulp.src(js)
    .pipe coffee_filter
    .pipe(coffee bare: true).on('error', errorHandler 'Coffee Script')
    .pipe(coffee_filter.restore())
    .pipe(sourcemaps.init())
    .pipe(concat 'script.js')
    .pipe(uglify())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest './project/static/js/')


gulp.task 'css', ->
  gulp.src(css)
    .pipe(stylus use: nib(), compress: true).on('error', errorHandler 'Stylus')
    .pipe(sourcemaps.init())
    .pipe(concat 'style.css')
    .pipe(cleancss())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest './project/static/css/')


gulp.task 'images', ->
  gulp.src(images)
    .pipe(gulp.dest './project/static/images/')


gulp.task 'watch', ->
  gulp.watch js, ['js']
  gulp.watch css, ['css']
  gulp.watch images, ['images']


gulp.task 'default', ['js', 'css', 'images', 'watch'], ->
