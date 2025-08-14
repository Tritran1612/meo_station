#!/bin/sh
set -e

echo "🚀 Starting Meo Stationery..."

# Only run migrations if DATABASE_URL is set
if [ -n "$DATABASE_URL" ]; then
    echo "🔄 Running database migrations..."
    prisma migrate deploy
else
    echo "⚠️  No DATABASE_URL found, skipping migrations"
fi

echo "🎯 Starting Next.js application..."
exec "$@"
