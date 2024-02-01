#! /bin/sh

# The Docker Minio Setup Script

set -e

# Wait for minio server to be available...
while ! curl -s minio:9000 > /dev/null; do
  sleep 1
  echo "Waiting for Minio server to become available..."
done

echo "1: Configuring the setup access to the minio server..."
echo "${MINIO_ROOT_USER}"
echo "${MINIO_ROOT_PASSWORD}"
mc config host add minio http://minio:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"

echo "2: Creating the 'cookpendium' bucket..."
mc mb -p "minio/${STORAGE_BUCKET_NAME}"

echo "3: Set the bucket policy to 'download' - minio doesn't allow per-object policies..."
mc policy set download "minio/${STORAGE_BUCKET_NAME}"
