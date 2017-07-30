FROM debian:latest

ENV BASEDIR=/root/rasp/

RUN mkdir $BASEDIR

# required packages
RUN apt-get update && apt-get install -y \
  netcdf-fortran libpng15 iproute-tc tcp_wrappers-libs sendmail procmail psmisc procps-ng mailx \
  findutils ImageMagick perl-CPAN ncl netcdf libpng libjpeg-turbo which
  
# configure CPAN and install required modules
RUN (echo y;echo o conf prerequisites_policy follow;echo o conf commit) | cpan \
  && cpan install Proc/Background.pm

# fix dependencies
RUN ln -s libnetcdff.so.6 /lib64/libnetcdff.so.5 \
  && ln -s libnetcdf.so.11 /lib64/libnetcdf.so.7


WORKDIR /root/

ADD raspGM.tar.xz $BASEDIR
ADD raspGM-bin.tar.xz $BASEDIR
ADD rangs.tar.xz $BASEDIR
ADD UKregions.tar.xz $BASEDIR


#
# Set environment for interactive container shells
#
RUN echo export BASEDIR=$BASEDIR >> /etc/bashrc \
  && echo export PATH+=:\$BASEDIR/bin >> /etc/bashrc

 
CMD ["bash"]
# CMD ["cd $BASEDIR ; runGM PANOCHE"]
