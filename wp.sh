#!/bin/bash 
#wget http://wordpress.org/latest.tar.gz 
#tar -xzf latest.tar.gz
#mv wordpress/* .
#rm -rf wordpress/ latest.tar.gz wp-content/themes/twenty* wp-content/plugins/akismet wp-content/plugins/hello.php readme.html
#git clone https://github.com/jackcutting/wp-base-theme.git wp-content/themes/themename
#subl .

# echo -n "Enter the theme name:"
# read THEMENAME
# echo $THEMENAME

THEMENAME=''
THEMENAMENS=''
AUTHOR=''
AUTHORURI=''
VERSION=''

# OS=$(uname)

get_theme_name() {

	printf "Enter the theme name: "
	read TEMP_THEMENAME

	if [ -z "$TEMP_THEMENAME" ]; then 
		get_theme_name
	else
		THEMENAME=$TEMP_THEMENAME
		THEMENAMENS="${TEMP_THEMENAME// /}" # | sed 's/[[:space:]]//g'
	fi

}

get_author_name() {

	printf "Enter the theme author: "
	read TEMP_AUTHOR

	if [ -z "$TEMP_AUTHOR" ]; then 
		get_author_name
	else
		AUTHOR=$TEMP_AUTHOR
	fi

}

get_author_uri() {

	printf "Enter the author URI (include http[s]://): "
	read TEMP_AUTHORURI

	if [ -z "$TEMP_AUTHORURI" ]; then 
		get_author_uri
	else
		AUTHORURI=$TEMP_AUTHORURI
	fi

}

get_version() {

	printf "Enter the theme version:[1.0] "
	read TEMP_VERSION

	if [ -z "$TEMP_VERSION" ]; then 
		VERSION='1.0'
	else
		VERSION=$TEMP_VERSION
	fi

}

get_theme_name
get_author_name
get_author_uri
get_version

# download and extract the latest wordpress
curl -O https://wordpress.org/latest.tar.gz 
tar -xzf latest.tar.gz
mv wordpress/* .

# remove not-needed and unsecure files
rm -rf wordpress/ latest.tar.gz readme.html wp-content/themes/twenty* wp-content/plugins/akismet wp-content/plugins/hello.php

# clone base theme and add in theme variables
git clone https://github.com/jackcutting/wp-base-theme.git wp-content/themes/$THEMENAMENS
sed -i.bak s/"Theme Name: Theme Name"/"Theme Name: $THEMENAME"/ wp-content/themes/$THEMENAMENS/style.scss
sed -i.bak s/"Author: Jack Cutting"/"Author: $AUTHOR"/ wp-content/themes/$THEMENAMENS/style.scss
sed -i.bak s/"Author URI: http:\/\/www.example.co.uk\/"/"Author URI: $AUTHORURI"/ wp-content/themes/$THEMENAMENS/style.scss
sed -i.bak s/"Version: 1.0"/"Version: $VERSION"/ wp-content/themes/$THEMENAMENS/style.scss

# ensure new theme is default when installed
sed -i.bak s/"define('WP_DEBUG', false);"/"define('WP_DEBUG', false);"\
\
"define('WP_DEFAULT_THEME', '$THEMENAMENS');"/ wp-config-sample.php

# if [ $OS == 'Darwin' ]; then
# 	open https://wordpress.org/
# fi

echo '========================================================'
echo 'Wordpress installed with theme: '$THEMENAME'!'
echo '========================================================'
