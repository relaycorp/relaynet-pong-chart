module.exports = {
    branch: 'master',
    extends: '@relaycorp/shared-config',
    plugins: [
        ['@semantic-release/npm', { npmPublish: false }],
    ]
};
