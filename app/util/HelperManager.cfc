/**
 * @accessors true
 */
component {

	property beanFactory;
	property config;
	property directories;
	property suffix;

	public any function init() {
		templates = {};
		return this;
	}

	public function setDirectories(required array directories) {
		variables.directories = listToArray(arrayToList(arguments.directories));
	}

	private void function appendSuffix() {

		var i = "";
		for (i = 1; i <= arrayLen(directories); i++) {
			directories[i] = directories[i] & suffix;
		}

	}

	public void function postProcessBeanFactory(any beanFactory) {
		appendSuffix();
		addHelpers();
	}

	public void function addHelpers() {

		var helpers = getHelpers();
		var container = getPageContext().getFusionContext().hiddenScope;

		if (!structKeyExists(container, "$")) {
			container["$"] = {};
		}

		structAppend(container["$"], helpers);

	}

	public struct function getHelpers() {

		if (!structKeyExists(variables, "helpers")) {
			variables.helpers = loadHelpers();
		}

		return variables.helpers;

	}

	private struct function loadHelpers() {

		var helpers = {};
		var i = "";
		var j = "";

		for (i = 1; i <= arrayLen(directories); i++) {

			var directory = expandPath(directories[i]);

			if (directoryExists(directory)) {

				var files = directoryList(directory, false, "query", "*.cfc");

				for (j = 1; j <= files.recordCount; j++) {

					var helper = {};
					helper.name = listFirst(files.name[j], ".");

					if (!structKeyExists(helpers, helper.name)) {

						helper.classPath = getClassPath(directories[i], helper.name);
						helper.path = directories[i] & files.name[j];
						helper.object = createObject("component", helper.classPath);

						if (structKeyExists(helper.object, "init")) {
							helper.object = helper.object.init();
						}

						// can't use the beanInjector to autowire since the beanInjector uses helpers to get a reference to the bean factory
						if (structKeyExists(helper.object, "setBeanFactory")) {
							helper.object.setBeanFactory(beanFactory);
						}

						if (structKeyExists(helper.object, "setConfig")) {
							helper.object.setConfig(config);
						}

						templates[helper.name] = helper.path;
						helpers[helper.name] = helper.object;

					}

				}

			}

		}

		return helpers;

	}

	private string function getClassPath(string directory, string name) {
		directory = replace(directory, "\", "/", "all");
		directory = arrayToList(listToArray(directory, "/"), ".");
		return directory & "." & name;
	}

	public struct function getTemplates() {
		return templates;
	}

}