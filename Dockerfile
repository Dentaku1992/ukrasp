FROM debian:latest

ENV BASEDIR=/root/rasp/

RUN mkdir $BASEDIR

ADD *.tar.xz $BASEDIR
ADD libjasper.so.1 libpng15.so.15 /lib64/

# required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl mailutils psmisc procps ncl-ncarg \
  libpng16-16 libjpeg62-turbo iproute2 libwrap0 \
  findutils imagemagick netpbm perl libproc-background-perl ncl-tools netcdf-bin \
  libnetcdff6 \
  vim wget

# The exes are linked to old versions of the libs.
RUN cd /usr/lib/x86_64-linux-gnu \
  && ln -s libnetcdff.so.6 libnetcdff.so.5 \
  && ln -s libnetcdf.so.11 libnetcdf.so.7 \
  && ln -s libpng15.so.16 libpng15.so.15


WORKDIR /root/


#
# Set environment for interactive container shells
#
RUN echo "export BASEDIR=$BASEDIR" >> /root/.bashrc \
  && echo 'export PATH+=:$BASEDIR/bin' >> /root/.bashrc \
  && echo 'export PERL5LIB=.' >> /root/.bashrc \
  && echo 'export NCARG_ROOT=/' >> /root/.bashrc \
  && echo 'cat PANOCHE/LOG/metgrid.out' >>/root/.bash_history \
  && echo 'cat PANOCHE/LOG/GM.stderr' >>/root/.bash_history \
  && echo 'cd /root/rasp; runGM PANOCHE' >>/root/.bash_history \
  && true
 
CMD ["bash"]
