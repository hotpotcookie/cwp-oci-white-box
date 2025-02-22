#!/bin/bash
mark_on=$(cat /etc/modsecurity/modsecurity.conf | grep "SecRuleEngine On" | cut -d '#' -f 2)
if [[ $mark_on == "@" ]]; then
        echo "enabling SecRuleEngine to On ..."
        sed -i 's/#@#SecRuleEngine On/SecRuleEngine On/' /etc/apache2/apache2.conf
        sed -i 's/#@#SecRuleEngine On/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf
        sed -i 's/#@#SecRuleEngine On/SecRuleEngine On/' /etc/apache2/sites-available/000-default.conf

        sed -i 's/SecRuleEngine DetectionOnly/#@#SecRuleEngine DetectionOnly/' /etc/apache2/apache2.conf
        sed -i 's/SecRuleEngine DetectionOnly/#@#SecRuleEngine DetectionOnly/' /etc/modsecurity/modsecurity.conf
        sed -i 's/SecRuleEngine DetectionOnly/#@#SecRuleEngine DetectionOnly/' /etc/apache2/sites-available/000-default.conf

else
        echo "enabling SecRuleEngine to DetectionOnly ..."
        sed -i 's/SecRuleEngine On/#@#SecRuleEngine On/' /etc/apache2/apache2.conf
        sed -i 's/SecRuleEngine On/#@#SecRuleEngine On/' /etc/modsecurity/modsecurity.conf
        sed -i 's/SecRuleEngine On/#@#SecRuleEngine On/' /etc/apache2/sites-available/000-default.conf

        sed -i 's/#@#SecRuleEngine DetectionOnly/SecRuleEngine DetectionOnly/' /etc/apache2/apache2.conf
        sed -i 's/#@#SecRuleEngine DetectionOnly/SecRuleEngine DetectionOnly/' /etc/modsecurity/modsecurity.conf
        sed -i 's/#@#SecRuleEngine DetectionOnly/SecRuleEngine DetectionOnly/' /etc/apache2/sites-available/000-default.conf
fi
echo "reloading apache2.service ..."
systemctl reload apache2.service & wait