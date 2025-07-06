#!/bin/bash

# Fix WordPress Static Site Paths
# This script converts absolute paths to relative paths for local/GitHub Pages hosting

echo "🔧 Fixing file paths in static WordPress build..."

# Backup the original file
cp index.html index.html.backup
echo "✅ Created backup: index.html.backup"

# Fix all absolute paths starting with /wp- to relative paths
echo "🔄 Converting absolute paths to relative paths..."

# Fix CSS and JS file paths
sed -i 's|href="/wp-|href="wp-|g' index.html
sed -i 's|src="/wp-|src="wp-|g' index.html

# Fix image paths in src and srcset attributes
sed -i 's|src="/wp-content/|src="wp-content/|g' index.html
sed -i 's|srcset="/wp-content/|srcset="wp-content/|g' index.html

# Fix background image URLs in CSS
sed -i "s|url('/wp-content/|url('wp-content/|g" index.html

# Fix other href attributes pointing to wp-content
sed -i 's|href="/wp-content/|href="wp-content/|g' index.html

# Fix content attributes (like meta tags)
sed -i 's|content="/wp-content/|content="wp-content/|g' index.html

# Fix any remaining wp-includes paths
sed -i 's|"/wp-includes/|"wp-includes/|g' index.html

# Fix API endpoints and feeds (these should stay absolute for WordPress)
sed -i 's|href="/feed/"|href="./feed/"|g' index.html
sed -i 's|href="/comments/feed/"|href="./comments/feed/"|g' index.html
sed -i 's|href="/wp-json/"|href="./wp-json/"|g' index.html
sed -i 's|href="/xmlrpc.php?rsd"|href="./xmlrpc.php?rsd"|g' index.html

echo "✅ Fixed the following path types:"
echo "   - CSS and JS file references"
echo "   - Image src and srcset attributes"
echo "   - Background image URLs"
echo "   - Meta tag content attributes"
echo "   - API endpoints and feeds"

# Count the changes made
CHANGES=$(diff index.html.backup index.html | grep "^<\|^>" | wc -l)
echo "📊 Made changes to $((CHANGES/2)) lines"

# Verify some key files exist
echo ""
echo "🔍 Verifying key files exist:"
if [ -f "wp-content/themes/twentytwentyfive/style.css" ]; then
    echo "✅ Theme CSS file found"
else
    echo "❌ Theme CSS file missing"
fi

if [ -f "wp-includes/css/dashicons.min.css" ]; then
    echo "✅ Dashicons CSS file found"
else
    echo "❌ Dashicons CSS file missing"
fi

if [ -f "wp-includes/blocks/navigation/style.min.css" ]; then
    echo "✅ Navigation CSS file found"
else
    echo "❌ Navigation CSS file missing"
fi

echo ""
echo "🎉 Path fixing complete!"
echo "💡 You can now view index.html locally or host it on GitHub Pages"
echo "📝 Original file backed up as index.html.backup"
