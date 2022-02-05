NAME := aquatic
WORKING_NAME := ${NAME}-working-container
BUILD_NAME := ${NAME}-build-working-container

default: .build-container

.build-app:
	buildah rm ${BUILD_NAME} || true
	buildah from --name ${BUILD_NAME} debian
	buildah run ${BUILD_NAME} useradd -m build
	buildah run ${BUILD_NAME} apt update
	buildah run ${BUILD_NAME} apt full-upgrade
	buildah run ${BUILD_NAME} apt install -y build-essential pkg-config curl libssl-dev
	buildah run --user build ${BUILD_NAME} curl -o /home/build/install-rustup.sh --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs
	buildah run --user build ${BUILD_NAME} sh /home/build/install-rustup.sh -y
	buildah run --user build ${BUILD_NAME} /home/build/.cargo/bin/cargo install aquatic
	touch .build-app

.build-container: .build-app
	buildah rm ${WORKING_NAME} || true
	buildah from --name ${WORKING_NAME} debian
	buildah copy --from ${BUILD_NAME} ${WORKING_NAME} /home/build/.cargo/bin/aquatic /app/
	buildah config --author "AkhIL <akhilman@gmail.com>" --port 3000 --user nobody --cmd /app/aquatic ${WORKING_NAME}
	buildah commit ${WORKING_NAME} ${NAME}
	touch .build-container

clean:
	buildah rm ${WORKING_NAME} ${BUILD_NAME}
	rm .build-container .build-app
