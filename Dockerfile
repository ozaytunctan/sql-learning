FROM postgres
RUN sed -i 's/^# *\(en_US.UTF-8\|tr_TR.UTF-8\)/\1/' /etc/locale.gen && \ locale-gen
ENV LANG tr_TR.utf8