top_dir = .
log_dir = $(top_dir)/log

create_doc=bin/create_doc.sh

doc:
	$(create_doc)

clean:
	rm -rf $(log_dir)

commit:
	EDITOR=vi git commit -a

push:
