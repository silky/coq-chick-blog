FROM ubuntu:14.10
MAINTAINER Guillaume Claret

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gcc make git
RUN apt-get install -y curl m4 ruby

# OCaml
WORKDIR /root
RUN curl -L https://github.com/ocaml/ocaml/archive/4.02.1.tar.gz |tar -xz
WORKDIR ocaml-4.02.1
RUN ./configure && make world.opt && make install

# Camlp4
WORKDIR /root
RUN curl -L https://github.com/ocaml/camlp4/archive/4.02.1+1.tar.gz |tar -xz
WORKDIR camlp4-4.02.1-1
RUN ./configure && make all && make install

# OPAM
WORKDIR /root
RUN curl -L https://github.com/ocaml/opam/archive/1.2.0.tar.gz |tar -xz
WORKDIR opam-1.2.0
RUN ./configure && make lib-ext && make && make install

# Initialize OPAM
RUN opam init
ENV OPAMJOBS 4

# Coq
RUN opam install -y coq.8.4.5

# Coq repositories
RUN opam repo add coq-stable https://github.com/coq/repo-stable.git

# Dependencies
RUN opam install -y coq:list-string coq:error-handlers coq:function-ninjas coq:moment
RUN opam install -y lwt cohttp

# Build
WORKDIR /root
RUN curl -L https://github.com/clarus/coq-chick-blog/archive/master.tar.gz |tar -xz
WORKDIR coq-chick-blog-master
RUN curl -L https://github.com/clarus/coq-red-css/releases/download/coq-blog.1.0.2/style.min.css >extraction/static/style.min.css
RUN eval `opam config env`; ./configure.sh && make
WORKDIR extraction
RUN eval `opam config env`; make

# Run the server
EXPOSE 8008
CMD eval `opam config env`; ./chickBlog.native
