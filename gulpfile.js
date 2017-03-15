var gulp = require('gulp');
var pegjs = require('gulp-pegjs');
var dogescript = require('gulp-dogescript');

var SRC = "src/";
var DIST = "dist";

gulp.task('peg', function() {
	return gulp.src(SRC+"**/*.pegjs")
	.pipe(pegjs({
		format: 'commonjs'
	}))
	.pipe(gulp.dest(DIST));
});

gulp.task('djs', function() {
	return gulp.src(SRC+"**/*.djs")
	.pipe(dogescript())
	.pipe(gulp.dest(DIST));
});

gulp.task('default', ['peg', 'djs']);
