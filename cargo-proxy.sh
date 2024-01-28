#!/usr/bin/env bash
# this script sanatizes the option supplied from the lsp based on the current workspace project
# it filters the feature flags and checks the project target to use custom `cargo` for projects that need that

CARGO_BIN="/root/.rustup/toolchains/esp/bin/cargo"

# Generate the list of allowed features
allowed_features=($($CARGO_BIN read-manifest | jq -r '.features | keys | @sh' | tr -d \'))
echo ${allowed_features[@]} >> /tmp/cargo-log.txt

# Function to check if a feature is availible in the rust project
feature_allowed() {
	local value=$1
	for allowed_feature in "${allowed_features[@]}"; do
		if [[ $allowed_feature == $value ]]; then
			return 0
		fi
	done
	return 1
}

# Array to store valid features and other arguments
valid_features=()
other_args=()

# Parse arguments
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-F|--features)
		# Split the argument into individual values based on comma or whitespace
		IFS=', ' read -ra values <<< "$2"
		# Filter and aggregate values
		for value in "${values[@]}"; do
			if feature_allowed "$value"; then
				valid_features+=("$value")
			fi
		done
		shift # past argument
		shift # past value
		;;
		*)    # unknown option
		other_args+=("$1")
		shift # past argument
		;;
	esac
done

if [ "${#valid_features[@]}" -gt "0" ]; then
	$CARGO_BIN ${other_args[@]} -F "${valid_features[@]}"
else
	$CARGO_BIN ${other_args[@]}
fi
