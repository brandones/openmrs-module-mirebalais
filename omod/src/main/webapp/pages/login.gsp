<!-- This is the login page -->
<%
    ui.includeFragment("emr", "standardEmrIncludes")

    ui.setPageTitle(ui.message("mirebalais.login.welcomeHeading"))
%>

<style type="text/css">
    #login-form input, #login-form select {
        display: block;
        margin-bottom: 2em;
    }

    #login-form label {
        display: block;
        color: #621B4B;
    }

    #login-form {
        border: 1px #B9B299 solid;
        border-radius: 5px;
        background-color: #e0e0e0;
        padding: 1em;
    }

    #cannot-login {
        position: relative;
        bottom: 0;
        left: 0;
    }

    h2 {
        margin-top: 0px;
    }

</style>

<div id="content" class="container">

    <img src="${ ui.resourceLink("mirebalais", "images/PIH_ZL_plum_940.jpg") }"/>

    <h1>${ ui.message("mirebalais.login.welcomeHeading") }</h1>

    <form id="login-form" method="post" autocomplete="off">
        <h2>${ ui.message("mirebalais.login.loginHeading") }</h2>

        ${ ui.includeFragment("emr", "infoAndErrorMessage") }

        <label for="username">
            ${ ui.message("mirebalais.login.username") }
        </label>
        <input id="username" type="text" name="username"/>

        <label for="password">
            ${ ui.message("mirebalais.login.password") }
        </label>
        <input id="password" type="password" name="password"/>

        <label for="sessionLocation">
            ${ ui.message("mirebalais.login.sessionLocation") }
        </label>
        <select id="sessionLocation" name="sessionLocation" size="${ locations.size() }">
            <% locations.each { %>
                <option <% if (it == lastSessionLocation) { %> selected="true" <% } %> value="${ it.id }">${ ui.format(it) }</option>
            <% } %>
        </select>

        <input id="login-button" type="submit" value="${ ui.message("mirebalais.login.button") }"/>

        <div id="cannot-login">
            <a href="javascript:void(0)">${ ui.message("mirebalais.login.cannotLogin") }</a>
            <div id="cannot-login-popup">
                ${ ui.message("mirebalais.login.cannotLoginInstructions") }
            </div>
        </div>

    </form>

</div>

<script type="text/javascript">
	document.getElementById('username').focus();

    \$(function() {
        \$('#cannot-login-popup').dialog({
            autoOpen: false,
            modal: true,
            title: "${ ui.message("mirebalais.login.cannotLogin") }",
            width: 750,
            height: 200
        });
        \$('#cannot-login > a').click(function() {
            \$('#cannot-login-popup').dialog('open');
        })
    });
</script>