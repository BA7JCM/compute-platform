work_dir=$(cd "$(dirname "$0")" && pwd)
output_dir=${1:-$work_dir}
rm /iso/ -rf
echo "delete $output_dir/MyNode*"
rm $output_dir/MyNode* -rf
