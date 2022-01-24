<?php
    $browsershot = new Browsershot('');
    $browsershot
        ->noSandbox()
        ->waitUntilNetworkIdle();

    if (app()->environment() !== 'local') {
        $browsershot->addChromiumArguments([
            'single-process',
            'disable-dev-shm6-usage',
            'disable-gpu',
            'no-zygote'
        ]);
    }