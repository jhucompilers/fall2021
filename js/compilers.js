// Global object for data and functions
compilers = {
	onLoad: function() {
		if (compilers.pageCategory) {
			console.log("Found page category");
			activeLink = document.getElementById("navbar_" + compilers.pageCategory);
			if (activeLink) {
				console.log("Found active link");
				activeLink.classList.add("active");
			}
		}
	}
}

// vim:ts=2:
